import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  FavoritesService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _favoritesCollection {
    final uid = _uid;
    if (uid == null) return null;
    return _favoritesCollectionForUser(uid);
  }

  CollectionReference<Map<String, dynamic>> _favoritesCollectionForUser(
    String uid,
  ) {
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  String _requireUid() {
    final uid = _uid;
    if (uid == null) {
      throw StateError('User must be signed in to manage favorites.');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> _requireFavoritesCollection() {
    final uid = _requireUid();
    return _favoritesCollectionForUser(uid);
  }

  Future<void> addFavorite(String workspaceId) async {
    if (workspaceId.isEmpty) {
      throw ArgumentError('workspaceId must not be empty.');
    }

    await _requireFavoritesCollection().doc(workspaceId).set({
      'workspaceId': workspaceId,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> toggleFavorite(String workspaceId, bool currentlyFavorite) {
    return currentlyFavorite
        ? removeFavorite(workspaceId)
        : addFavorite(workspaceId);
  }

  Future<void> addFavoriteFromWorkspace(Map<String, dynamic> workspace) async {
    final workspaceId = (workspace['id'] ?? workspace['workspaceId'] ?? '')
        .toString();
    if (workspaceId.isEmpty) {
      throw StateError('User must be signed in and workspace must have an id.');
    }

    await addFavorite(workspaceId);
  }

  Future<void> removeFavorite(String workspaceId) async {
    final favorites = _favoritesCollection;
    if (favorites == null || workspaceId.isEmpty) return;
    await favorites.doc(workspaceId).delete();
  }

  Stream<bool> isFavorite(String workspaceId) {
    final favorites = _favoritesCollection;
    if (favorites == null || workspaceId.isEmpty) {
      return Stream<bool>.value(false);
    }
    return _isFavoriteInCollection(favorites, workspaceId);
  }

  Stream<bool> isFavoriteForUser(String uid, String workspaceId) {
    if (uid.isEmpty || workspaceId.isEmpty) {
      return Stream<bool>.value(false);
    }
    return _isFavoriteInCollection(
      _favoritesCollectionForUser(uid),
      workspaceId,
    );
  }

  Stream<bool> _isFavoriteInCollection(
    CollectionReference<Map<String, dynamic>> favorites,
    String workspaceId,
  ) {
    return favorites.doc(workspaceId).snapshots().map((doc) => doc.exists);
  }

  Stream<List<String>> getFavoriteWorkspaceIds() {
    final favorites = _favoritesCollection;
    if (favorites == null) {
      return Stream<List<String>>.value([]);
    }
    return _favoriteWorkspaceIdsFromCollection(favorites);
  }

  Stream<List<String>> getFavoriteWorkspaceIdsForUser(String uid) {
    if (uid.isEmpty) {
      return Stream<List<String>>.value([]);
    }
    return _favoriteWorkspaceIdsFromCollection(
      _favoritesCollectionForUser(uid),
    );
  }

  Stream<List<String>> _favoriteWorkspaceIdsFromCollection(
    CollectionReference<Map<String, dynamic>> favorites,
  ) {
    return favorites.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => (doc.data()['workspaceId'] ?? doc.id).toString())
          .toList();
    });
  }

  Future<List<Map<String, dynamic>>> getWorkspacesByIds(
    List<String> workspaceIds,
  ) async {
    final uniqueIds = workspaceIds
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (uniqueIds.isEmpty) return [];

    final docs = await Future.wait(
      uniqueIds.map((id) => _firestore.collection('workspaces').doc(id).get()),
    );

    final workspacesById = <String, Map<String, dynamic>>{};
    for (final doc in docs) {
      if (!doc.exists) continue;
      final data = doc.data();
      if (data == null) continue;
      workspacesById[doc.id] = {...data, 'id': doc.id, 'workspaceId': doc.id};
    }

    return workspaceIds
        .map((id) => workspacesById[id])
        .whereType<Map<String, dynamic>>()
        .toList();
  }
}
