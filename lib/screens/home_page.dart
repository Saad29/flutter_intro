import 'dart:math';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config.dart';
import 'package:flutter_web/screens/second_page.dart';
import '../simple_animations_package.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SecondPage()));
        },
        child: const Icon(Icons.arrow_forward),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        brightness: Brightness.dark,
        title: Text(
          'Introduction',
          style: TextStyle(
            color: Colors.white,
            fontFamily: zenDots,
            fontSize: biggerText,
            //letterSpacing: titleTextSpacing
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ParticleBackgroundPage(),
    );
  }
}

class ParticleBackgroundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: AnimatedBackground()),
        Positioned.fill(child: Particles(30)),
        Positioned.fill(
            child: Column(
          children: [
            CenteredText(),
            const SizedBox(
              height: 60,
            ),
            Expanded(child: BulletList()),
          ],
        )),
      ],
    );
  }
}

class Particles extends StatefulWidget {
  final int numberOfParticles;

  Particles(this.numberOfParticles);

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Rendering(
      startTime: Duration(seconds: 30),
      onTick: _simulateParticles,
      builder: (context, time) {
        return CustomPaint(
          painter: ParticlePainter(particles, time),
        );
      },
    );
  }

  _simulateParticles(Duration time) {
    particles.forEach((particle) => particle.maintainRestart(time));
  }
}

class ParticleModel {
  Animatable tween;
  double size;
  AnimationProgress animationProgress;
  Random random;

  ParticleModel(this.random) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 3000 + random.nextInt(6000));

    tween = MultiTrackTween([
      Track("x").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("y").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
    ]);
    animationProgress = AnimationProgress(duration: duration, startTime: time);
    size = 0.2 + random.nextDouble() * 0.4;
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  List<ParticleModel> particles;
  Duration time;

  ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withAlpha(50);

    particles.forEach((particle) {
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      final position =
          Offset(animation["x"] * size.width, animation["y"] * size.height);
      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xff8a113a), end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xff440216), end: Colors.blue.shade600))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}

class CenteredText extends StatelessWidget {
  const CenteredText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Welcome to Flutter!",
        style: TextStyle(
            color: Colors.white, fontWeight: fontWeight, fontFamily: zenDots),
        textScaleFactor: 4,
      ),
    );
  }
}

class BulletList extends StatefulWidget {
  @override
  _BulletListState createState() => _BulletListState();
}

class _BulletListState extends State<BulletList> {
  Emoji emo = Emoji.byName('expressionless face');
  Emoji smile = Emoji.byName('winking face with tongue');

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          hoverColor: Colors.white10,
          leading: Icon(
            Icons.circle,
            color: Colors.white,
            size: iconSize,
          ),
          title: Text(
            'Googles open source, x-platform declarative UI toolkit',
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeight,
                fontFamily: zenDots),
            textScaleFactor: 3,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.circle,
            color: Colors.white,
            size: iconSize,
          ),
          title: Text(
            'Natively compiles to Android, iOS, macOS, Linux, Windows and Web! ',
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeight,
                fontFamily: zenDots),
            textScaleFactor: 3,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.circle,
            color: Colors.white,
            size: iconSize,
          ),
          title: Text(
            'Uses Dart (initially used JS ${emo.char})',
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeight,
                fontFamily: zenDots),
            textScaleFactor: 3,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(
            Icons.circle,
            color: Colors.white,
            size: iconSize,
          ),
          title: Text(
            'Inspired by react ${smile.char}, or reactive programming in general',
            style: TextStyle(
                color: Colors.white,
                fontWeight: fontWeight,
                fontFamily: zenDots),
            textScaleFactor: 3,
          ),
        ),
      ],
    );
  }
}
