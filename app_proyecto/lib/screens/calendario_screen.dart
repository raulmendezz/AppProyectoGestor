import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/eventos_provider.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class CalendarioScreen extends StatelessWidget {
  const CalendarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final dates = generarDiasMes(2026, 11);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1C3A70),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Row(
                          children: [
                            Text('Noviembre', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_up, color: Colors.white),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.white), onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.chevron_left, color: Colors.white),
                        Text('Noviembre 2026', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Icon(Icons.chevron_right, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: daysOfWeek.map((day) => Text(day, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))).toList(),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio: 1.2, 
                      ),
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        if (dates[index].isEmpty) return const SizedBox();
                        
                        bool isSelected = dates[index] == '9';
                        bool hasEvent = dates[index] == '27'; 

                        return Center(
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amber : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  dates[index],
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF1C3A70) : Colors.white,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                if (hasEvent)
                                  Positioned(
                                    bottom: 4,
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
              children: eventosProvider.eventos.map(_buildEventCard).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEventCard(Evento evento) {
    final time = evento.hora;
    final title = evento.titulo;
    final subtitle = evento.estado;
    final duration = evento.horario;
    final borderColor = evento.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SizedBox(
              width: 45,
              child: Text(time, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: borderColor, width: 4)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                      const Icon(Icons.more_horiz, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(duration, style: const TextStyle(color: Colors.blue, fontSize: 12)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}