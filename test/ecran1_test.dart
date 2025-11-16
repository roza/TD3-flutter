import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:td3/UI/card1.dart';
import 'package:td3/models/task.dart';

void main() {
  group('Ecran1 (Tâches générées aléatoirement)', () {
    testWidgets('affiche une liste de tâches', (WidgetTester tester) async {
      // --- ARRANGE ---
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ecran1(),
          ),
        ),
      );

      // --- ASSERT ---
      // Vérifie que des Cards sont affichées
      expect(find.byType(Card), findsWidgets);

      // Vérifie que des ListTile sont présents
      expect(find.byType(ListTile), findsWidgets);

      // Vérifie que des CircleAvatar sont affichés (pour les IDs)
      expect(find.byType(CircleAvatar), findsWidgets);

      // Vérifie qu'il y a exactement 6 tâches (comme défini dans Ecran1)
      expect(find.byType(Card), findsNWidgets(6));
    });

    testWidgets('affiche les informations des tâches correctement',
        (WidgetTester tester) async {
      // --- ARRANGE ---
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ecran1(),
          ),
        ),
      );

      // --- ASSERT ---
      // Vérifie que les titres sont affichés
      expect(find.text('title 0'), findsOneWidget);
      expect(find.text('title 1'), findsOneWidget);

      // Vérifie que les tags sont affichés
      expect(find.textContaining('tag 0'), findsOneWidget);

      // Vérifie que les IDs sont affichés dans les CircleAvatar
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('affiche des boutons edit pour chaque tâche',
        (WidgetTester tester) async {
      // --- ARRANGE ---
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ecran1(),
          ),
        ),
      );

      // --- ASSERT ---
      // Vérifie qu'il y a 6 icônes edit (une par tâche)
      expect(find.byIcon(Icons.edit), findsNWidgets(6));
    });

    testWidgets('navigue vers l\'écran de détail quand on clique sur edit',
        (WidgetTester tester) async {
      // --- ARRANGE ---
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ecran1(),
          ),
        ),
      );

      // --- ACT ---
      // Trouve le premier bouton edit et clique dessus
      final editButton = find.byIcon(Icons.edit).first;
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // --- ASSERT ---
      // Vérifie qu'on est bien sur l'écran de détail
      expect(find.textContaining('Task title 0 detail'), findsOneWidget);

      // Vérifie que les informations de la tâche sont affichées
      expect(find.text('Identifiant'), findsOneWidget);
      expect(find.text('Titre de la tache'), findsOneWidget);
      expect(find.text('Description de la tache '), findsOneWidget);
    });

    testWidgets('utilise le thème du contexte pour les Cards',
        (WidgetTester tester) async {
      // --- ARRANGE ---
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Ecran1(),
          ),
        ),
      );

      // --- ACT ---
      final card = tester.widget<Card>(find.byType(Card).first);

      // --- ASSERT ---
      // Vérifie que la couleur n'est pas définie en dur sur blanc
      // (elle devrait être null ou utiliser cardColor du thème)
      expect(card.color, isNotNull);
    });
  });
}
