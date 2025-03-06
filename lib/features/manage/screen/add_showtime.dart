import 'package:flutter/material.dart';
import 'package:movie_app/Components/app_button.dart';
import 'package:movie_app/Components/list_display.dart';
import 'package:movie_app/Components/text_head.dart';
import 'package:movie_app/app.dart';
import 'package:movie_app/features/Search/widgets/search_box.dart';
import 'package:movie_app/models/hall.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/showtime.dart';
import 'package:movie_app/service/hall_service.dart';
import 'package:movie_app/service/showtime_service.dart';

class AddShowtimeScreen extends StatefulWidget {
  const AddShowtimeScreen({super.key, this.showtime});
  final Showtime? showtime;
  @override
  _AddShowtimeScreenState createState() => _AddShowtimeScreenState();
}

class _AddShowtimeScreenState extends State<AddShowtimeScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final searchFocusNode = FocusNode();
  int? selectedMovieId;
  String? selectedRoom;
  String? selectedTime;
  final hallService = HallService();
  final controllerApis = ControllerApi();
  final showtimeService = ShowtimeService();
  Future<List<Movies>> searchInfo = Future.value([]);
  void _search(String value) {
    value = value.toLowerCase();
    setState(() {
      searchInfo = controllerApis.searchMovie(value);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.showtime != null) {
      // Nếu có dữ liệu cũ, hiển thị trước
      selectedMovieId = widget.showtime!.movieid;
      selectedRoom = widget.showtime!.hallid;
      selectedTime = widget.showtime!.starttime;
      priceController.text = widget.showtime!.ticketprice.toString();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  // void _pickDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

  void _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _saveShowtime() {
    if (selectedMovieId == null ||
        selectedRoom == null ||
        selectedTime == null ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }
    final int ticketPrice = int.tryParse(priceController.text) ?? 0;
    if (ticketPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Giá vé không hợp lệ")),
      );
      return;
    }
    final showtimes = Showtime(
      movieid: selectedMovieId!,
      hallid: selectedRoom,
      starttime: selectedTime!,
      ticketprice: ticketPrice,
    );
    final newShowtimes = Showtime(
      showtimeid: widget.showtime?.showtimeid,
      movieid: selectedMovieId!,
      hallid: selectedRoom,
      starttime: selectedTime!,
      ticketprice: ticketPrice,
    );
    if (widget.showtime == null) {
      showtimeService.insertShowtime(showtimes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thêm suất chiếu thành công!")),
      );
    } else {
      showtimeService.updateShowtime(newShowtimes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật suất chiếu thành công!")),
      );
    }
    // print(showtimes);
    // showtimeService.insertShowtime(showtimes);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Thêm suất chiếu thành công!")),
    // );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm suất chiếu")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBox(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: _search,
              ),
              SizedBox(height: 10),
              ListDisplay<Movies>(
                listFuture: searchInfo,
                builder: (snapshot) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: TextHead(
                        text: "Không có dữ liệu",
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  final movies = snapshot.data!;
                  return Wrap(
                    children: movies.map((movie) {
                      return ChoiceChip(
                        label: Text(movie.title),
                        selected: selectedMovieId == movie.id,
                        onSelected: (selected) {
                          setState(() {
                            selectedMovieId = selected ? movie.id : null;
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
        
              SizedBox(height: 10),
              FutureBuilder<List<Hall>>(
                future: hallService.gethall(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("Không có phòng nào.");
                  }
        
                  final rooms = snapshot.data!;
        
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Selected room"),
                    value: selectedRoom,
                    items: rooms.map((room) {
                      return DropdownMenuItem(
                        value: room.hallid,
                        child: Text(room.nameHall),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = value!;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              // Row(
              //   children: [
              //     Text(selectedDate == null
              //         ? "Chọn ngày chiếu"
              //         : DateFormat('dd/MM/yyyy').format(selectedDate!)),
              //     Spacer(),
              //     ElevatedButton(onPressed: _pickDate, child: Text("Chọn")),
              //   ],
              // ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(selectedTime == null ? "Chọn giờ chiếu" : selectedTime!),
                  const Spacer(),
                  ElevatedButton(onPressed: _pickTime, child: Text("Chọn")),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Giá vé"),
              ),
              const SizedBox(height: 20),
              AppButton(
                text: widget.showtime == null ? 'Thêm' : 'Lưu chỉnh sửa',
                onPressed: _saveShowtime,
              )
            ],
          ),
        ),
      ),
    );
  }
}
