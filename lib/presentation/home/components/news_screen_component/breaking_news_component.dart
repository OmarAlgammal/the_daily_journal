import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:the_daily_journal/core/utils/extensions/screen_dimens.dart';
import 'package:the_daily_journal/routing/routes.dart';
import 'package:the_daily_journal/shared/theme/colors.dart';
import 'package:the_daily_journal/shared/widgets/authentication_mark.dart';

import '../../../../../shared/constance/gaps.dart';
import '../../../../../shared/constance/icons.dart';
import '../../../../../shared/widgets/news_title.dart';
import '../../../../domain/news/entities/news.dart';

class BreakingNewsComponent extends StatefulWidget {
  BreakingNewsComponent({Key? key, required this.news}) : super(key: key);

  final List<News> news;

  @override
  State<BreakingNewsComponent> createState() => _BreakingNewsComponentState();
}

class _BreakingNewsComponentState extends State<BreakingNewsComponent> {
  final _carouselController = CarouselController();

  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: NewsTitle(title: 'Breaking News'),
        ),
        CarouselSlider(
          carouselController: _carouselController,
          items: widget.news
              .map((e) => InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(AppRouts.displayNewsScreen, arguments: e);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 6),
                      child: BreakingNewsItem(news: e),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _currentPage = index;
              });
            },
            enableInfiniteScroll: false,
            aspectRatio: 2,
            enlargeCenterPage: true,
            height: (MediaQuery.of(context).size.height / 2) * .49,
            initialPage: 1,
            viewportFraction: .83,
          ),
        ),
        gap4,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.news.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 18.0,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: _currentPage == entry.key
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(.6),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class BreakingNewsItem extends StatelessWidget {
  const BreakingNewsItem({Key? key, required this.news}) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: blackColor.withOpacity(.8),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(
                    0,
                    1,
                  ), // Changes position of shadow
                ),
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Opacity(
              opacity: .5,
              child: Image.network(
                news.imageUrl,
                fit: BoxFit.cover,
                height: context.screenHeight() / 3.5,
                width: (context.screenWidth() / 10) * 9,
              ),
            ),
          ),
        ),
        Positioned(
          left: 18,
          top: 18,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                news.category,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                maxLines: 2,
              ),
            ),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 18,
          right: 18,
          child: SizedBox(
            width: context.screenWidth() * 1.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(news.agency,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                        maxLines: 2),
                    gap8,
                    const AuthenticationMark(),
                    gap8,
                    Text(
                      '5 hours ago',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onBackground,
                            //color: whiteColor,
                          ),
                    )
                  ],
                ),
                gap4,
                Text(
                  news.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onBackground
                      //color: whiteColor,
                      ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
