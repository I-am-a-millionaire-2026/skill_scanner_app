// پایه‌ای برای خطاهای Cloud Storage
class CloudStorageException implements Exception {}

// وقتی نوت ایجاد نشد
class CouldNotCreateNoteException extends CloudStorageException {}

// می‌توان کلاس‌های دیگر هم اضافه کرد: update، delete، read
class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}
