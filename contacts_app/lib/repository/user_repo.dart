
import 'package:contactsapp/dao_impl/user_impl.dart';
import 'package:contactsapp/dao_interface/user_dao.dart';
import 'package:contactsapp/model/user.dart';

class UserRepository {
  final UserDao _userDao = UserDaoImpl();

  UserRepository._();
  static final UserRepository repo = UserRepository._();

  Future<List<User>> fetchData() async{
    return await _userDao.getUserList();
  }

  Future<void> insertRecord(User user) async {
    try {
      await _userDao.insertUser(user);
    }catch(ex) {
      throw ex;
    }
  }

  Future<void> updateRecord(User user) async {
    try {
      await _userDao.updateUser(user);
    }catch(ex) {
      throw ex;
    }
  }

  Future<void> deleteRecord(int id) async {
    try {
      await _userDao.deleteUser(id);
    }catch(ex) {
      throw ex;
    }
  }

  Future<List<User>> fetchFavData() async{
    return await _userDao.getFavList();
  }

}