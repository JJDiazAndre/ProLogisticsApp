class RoleSelectorPage extends StatelessWidget {
  final UserProfile user;
  const RoleSelectorPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Si solo tiene un rol, saltamos directo al MainRouter
    if (user.roles.length == 1) {
      Future.microtask(() => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainRouter(user: user, activeRole: user.roles[0]))));
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Selecciona cómo quieres ingresar hoy:", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ...user.roles.map((role) => ListTile(
              title: Text(role.name),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (_) => MainRouter(user: user, activeRole: role))
                );
              },
            )).toList(),
          ],
        ),
      ),
    );
  }
}