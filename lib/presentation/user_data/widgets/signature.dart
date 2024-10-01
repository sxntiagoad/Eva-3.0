import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import '../../../providers/signature_provider.dart';

class SignatureWidget extends ConsumerStatefulWidget {
  final String? initialSignatureUrl;

  const SignatureWidget({super.key, this.initialSignatureUrl});

  @override
  ConsumerState<SignatureWidget> createState() => _SignatureWidgetState();
}

class _SignatureWidgetState extends ConsumerState<SignatureWidget> {
  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black87,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signatureProvider.notifier).setSignature(widget.initialSignatureUrl);
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signatureUrl = ref.watch(signatureProvider);
    final isEditing = ref.watch(isEditingProvider);

    return Column(
      children: [
        if (!isEditing && signatureUrl != null)
          Image.network(signatureUrl),
        if (isEditing)
          Signature(
            controller: _signatureController,
            width: 400,
            height: 200,
            backgroundColor: Colors.grey[200]!,
          ),
        ElevatedButton(
          onPressed: () async {
            if (isEditing) {
              final signatureImage = await _signatureController.toPngBytes();
              if (signatureImage != null) {
                await ref.read(signatureProvider.notifier).saveSignature(signatureImage);
                ref.read(isEditingProvider.notifier).state = false;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('La firma está vacía o no es válida')),
                );
              }
            } else {
              ref.read(isEditingProvider.notifier).state = true;
            }
          },
          child: Text(isEditing ? 'Guardar Firma' : 'Modificar Firma'),
        ),
      ],
    );
  }
}