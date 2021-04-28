import 'dart:math';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/config.dart';
import 'package:flutter_web/screens/last_page.dart';
import '../fade_in.dart';
import '../simple_animations_package.dart';

class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LastPage()));
        },
        child: const Icon(Icons.arrow_forward),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        brightness: Brightness.dark,
        title: Text(
          'Major adopters',
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

class BulletList extends StatefulWidget {
  @override
  _BulletListState createState() => _BulletListState();
}

class _BulletListState extends State<BulletList> {
  Emoji emo = Emoji.byName('winking face');
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        FadeIn(
          0.5,
          ListTile(
            hoverColor: Colors.white10,
            leading: Image(
              //fit: BoxFit.cover,
              image: AssetImage('assets/bmw.png'),
            ),
            title: Text(
              'The BMW android and iOS app',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: fontWeight,
                  fontFamily: zenDots),
              textScaleFactor: 3,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FadeIn(
          1,
          ListTile(
            leading: Image(
              //fit: BoxFit.cover,
              image: AssetImage('assets/google.png'),
            ),
            title: Text(
              'Google Ads, Stadia app, Assistant',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: fontWeight,
                  fontFamily: zenDots),
              textScaleFactor: 3,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FadeIn(
          1.5,
          ListTile(
            leading: Image(
              //fit: BoxFit.cover,
              width: 100,
              image: AssetImage('assets/tencent.png'),
            ),
            title: Text(
              'Tencent mobile app',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: fontWeight,
                  fontFamily: zenDots),
              textScaleFactor: 3,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FadeIn(
          2,
          ListTile(
            leading: Image(
              //fit: BoxFit.cover,
              image: AssetImage('assets/alibaba.png'),
            ),
            title: Text(
              'AliBaba e commerce app, largest in the world',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: fontWeight,
                  fontFamily: zenDots),
              textScaleFactor: 3,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FadeIn(
          2,
          ListTile(
            leading: Image(
              //fit: BoxFit.cover,
              image: AssetImage('assets/ebay.png'),
            ),
            title: Text(
              'Ebay motors app',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: fontWeight,
                  fontFamily: zenDots),
              textScaleFactor: 3,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FadeIn(
          2,
          ListTile(
            leading: Icon(
              Icons.circle,
              color: Colors.white,
              size: iconSize,
            ),
            title: Text(
              'Microsoft, Baidu, Grab, NY Times, Sony all have apps and contributions in Flutter (more can be found here https://flutter.dev/showcase) ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: fontWeight,
                  fontFamily: zenDots),
              textScaleFactor: 3,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FadeIn(
          2,
          ListTile(
            leading: Image(
              //fit: BoxFit.cover,
              image: AssetImage('assets/chi.png'),
            ),
            title: GestureDetector(
              child: Text(
                'Last but not the least, CHI Pouch Capture app ${emo.char}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: fontWeight,
                    fontFamily: zenDots),
                textScaleFactor: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
