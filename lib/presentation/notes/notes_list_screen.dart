import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../di/di.dart';
import '../home/cubit/beranda_notes_cubit.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaNotesCubit>()..loadNotes(),
      child: Scaffold(
        backgroundColor: AppColors.offWhite,
        appBar: AppBar(
          title: const Text('Catatan Saya'),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          foregroundColor: AppColors.darkerTeal,
        ),
        body: Column(
          children: [
            // Search Bar for Notes
            Padding(
              padding: EdgeInsets.all(AppPadding.p16.w),
              child: TextField(
                onChanged: (value) {
                  context.read<BerandaNotesCubit>().searchNotes(value);
                },
                decoration: InputDecoration(
                  hintText: 'Cari catatan...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Notes List
            Expanded(
              child: BlocBuilder<BerandaNotesCubit, BerandaNotesState>(
                builder: (context, state) {
                  if (state is BerandaNotesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BerandaNotesLoaded) {
                    final notes = state.notes;
                    if (notes.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          child: ListTile(
                            title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: note.isPinned ? const Icon(Icons.push_pin, color: AppColors.tealGreen) : null,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.noteDetailRoute,
                                arguments: {'note': note},
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text('Gagal mengambil catatan'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.noteDetailRoute);
          },
          backgroundColor: AppColors.tealGreen,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 80.r, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            'Belum ada catatan',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
