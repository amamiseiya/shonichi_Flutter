enum SNProperty { editingProject, editingSong }

class PropertyNotSetException implements Exception {
  SNProperty property;
}
