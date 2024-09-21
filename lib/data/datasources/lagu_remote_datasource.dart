import 'package:flutter_lagu_daerah_app/data/models/lagu_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class LaguRemoteDatasource {
  // final String baseUrl = 'https://part2.jagofullstack.com';
  final String baseUrl = 'http://192.168.100.4:8000';
  static String imageUrl = 'http://192.168.100.4:8000/storage/images';

  Future<LaguResponseModel> getLaguDaerah() async {
    final response = await http.get(Uri.parse('$baseUrl/api/lagudaerah'));
    if (response.statusCode == 200) {
      return LaguResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<LaguResponseModel> getLaguDaerahPages(int page) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/lagudaerah?page=$page'));
    if (response.statusCode == 200) {
      return LaguResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  //add new lagu
  Future<void> addLaguDaerah(
    String judul,
    String lagu,
    String daerah,
    XFile image,
  ) async {
    // final response = await http.post(
    //   Uri.parse('$baseUrl/api/lagudaerah'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode({
    //     'judul': judul,
    //     'lagu': lagu,
    //     'daerah': daerah,
    //   }),
    // );
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/lagudaerah'));

    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.fields.addAll({
      'judul': judul,
      'lagu': lagu,
      'daerah': daerah,
    });
    request.headers.addAll({
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to add data');
    }
  }

  //update lagu
  Future<void> updateLaguDaerah(
    int id,
    String judul,
    String lagu,
    String daerah,
    XFile? image,
  ) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/lagudaerah/$id'));

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    request.fields.addAll({
      'judul': judul,
      'lagu': lagu,
      'daerah': daerah,
    });
    request.headers.addAll({
      'Content-Type': 'application/json',
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  //delete lagu
  Future<void> deleteLaguDaerah(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/api/lagudaerah/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete data');
    }
  }
}
