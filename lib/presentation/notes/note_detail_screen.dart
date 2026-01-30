import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/resources/resources.dart';
import '../../di/di.dart';
import '../../domain/models/note/note_model.dart';
import '../home/cubit/beranda_notes_cubit.dart';
import '../home/cubit/beranda_notes_state.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel? note;

  const NoteDetailScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<BerandaNotesCubit>(),
      child: BlocListener<BerandaNotesCubit, BerandaNotesState>(
        listener: (context, state) {
          if (state is BerandaNoteCreated || state is BerandaNoteUpdated || state is BerandaNoteDeleted) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
            actions: [
              IconButton(
                icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                onPressed: () {
                  setState(() {
                    _isPinned = !_isPinned;
                  });
                },
              ),
              if (widget.note != null)
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _showDeleteDialog(context),
                  );
                }),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(AppPadding.p20.w),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'Judul',
                    border: InputBorder.none,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    style: TextStyle(fontSize: 16.sp),
                    decoration: const InputDecoration(
                      hintText: 'Mulai menulis...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () => _saveNote(context),
              backgroundColor: AppColors.tealGreen,
              child: const Icon(Icons.check, color: Colors.white),
            );
          }),
        ),
      ),
    );
  }

  void _saveNote(BuildContext context) {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final note = NoteModel(
      id: widget.note?.id,
      title: title.isEmpty ? 'Hening' : title,
      content: content,
      isPinned: _isPinned,
      createdAt: widget.note?.createdAt,
      updatedAt: DateTime.now(),
    );

    if (widget.note == null) {
      context.read<BerandaNotesCubit>().createNote(note);
    } else {
      context.read<BerandaNotesCubit>().updateNote(note);
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(diagContext), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(diagContext);
              context.read<BerandaNotesCubit>().deleteNote(widget.note!.id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
