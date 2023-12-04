import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:disiplean_clone/constants/style/text_style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  String androidVersion = 'Unknown';
  List<File> uploadedFiles = [];
  FilePickerResult? result;
  @override
  void initState() {
    super.initState();
    if (!FlutterDownloader.initialized) {
      FlutterDownloader.initialize(debug: true);
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
  /// function get android version
  Future<void> getAndroidVersion() async {
    AndroidDeviceInfo androidInfo;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      androidInfo = await deviceInfoPlugin.androidInfo;
      setState((){
        androidVersion = androidInfo.version.sdkInt.toString();
      });
  }

  /// function download file
  Future<void> _startDownload() async {
    await getAndroidVersion();
    /// handler for android 13
    if (androidVersion.isNotEmpty && int.parse(androidVersion) >= 33) {
      /// permission request for android 13
      if (await Permission.photos.request().isGranted) {
        final taskId = await FlutterDownloader.enqueue(
          url: 'https://picsum.photos/250?image=9',
          savedDir: '/storage/emulated/0/Download/',
          showNotification: true,
          openFileFromNotification: true,
        );
      }
    } else {
      if (await Permission.storage.request().isGranted) {
        final taskId = await FlutterDownloader.enqueue(
          url: 'https://picsum.photos/250?image=9',
          savedDir: '/storage/emulated/0/Download/',
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true,
        );
      }
    }
  }

  /// function upload file
  Future<void> _startUpload() async {
    await getAndroidVersion();
    if (androidVersion.isNotEmpty && int.parse(androidVersion) >= 33) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'csv'],
      );
      if (result != null) {
        setState(() {
          uploadedFiles.add(File(result!.files.single.path!));
        });
      }
    }
    else if (await Permission.storage.request().isGranted){
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'csv'],
      );
      if (result != null) {
        setState(() {
          uploadedFiles.add(File(result!.files.single.path!));
        });
      }
    }
  }

  /// show uploaded file
  Widget _buildUploadedFilesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File yang sudah diupload:',
          style: smNormalTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        // Menampilkan nama file dan tombol untuk menghapus
        for (int index = 0; index < uploadedFiles.length; index++)
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    uploadedFiles[index].path.split('/').last, // Menampilkan nama file saja
                    style: smNormalTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    // Hapus file dari daftar dan refresh tampilan
                    setState(() {
                      uploadedFiles.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Profile'),
          backgroundColor: const Color(0xFF6D9773),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Silahkan melakukan download template file dibawah ini untuk keperluan '
                    'penambahan profile',
                style: smNormalTextStyle.copyWith(
                  fontSize: 14
                )
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _startDownload,
                  child: const Text('Download File'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                  'Silahkan upload file yang sudah download pada tombol dibawah ini',
                  style: smNormalTextStyle.copyWith(
                      fontSize: 14
                  )
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _startUpload,
                  child: const Text('Upload File'),
                ),
              ),
              const SizedBox(height: 10),
              if (uploadedFiles.isNotEmpty)
                _buildUploadedFilesList(),
            ],
          ),
        ),
      ),
    );
  }
}
