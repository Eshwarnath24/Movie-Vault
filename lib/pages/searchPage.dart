import 'package:flutter/material.dart';

class ContentItem {
  final String title;
  final String type;
  final List<String> genres;
  final String language;
  final double rating;
  final int durationMins;
  final List<String> cast;
  final String imagePath;

  const ContentItem({
    required this.title,
    required this.type,
    required this.genres,
    required this.language,
    required this.rating,
    required this.durationMins,
    required this.cast,
    required this.imagePath,
  });
}

final List<ContentItem> kCatalog = [
  ContentItem(
    title: 'Master',
    type: 'movie',
    genres: ['Action', 'Thriller'],
    language: 'Tamil',
    rating: 7.2,
    durationMins: 179,
    cast: ['Vijay', 'Vijay Sethupathi', 'Malavika Mohanan'],
    imagePath: 'assets/images/master.jpg',
  ),
  ContentItem(
    title: 'Star Wars: A New Hope',
    type: 'movie',
    genres: ['Sci-Fi', 'Adventure'],
    language: 'English',
    rating: 8.6,
    durationMins: 121,
    cast: ['Mark Hamill', 'Harrison Ford', 'Carrie Fisher'],
    imagePath: 'assets/images/star_wars.jpg',
  ),
  ContentItem(
    title: 'Titanic',
    type: 'movie',
    genres: ['Romance', 'Drama'],
    language: 'English',
    rating: 7.9,
    durationMins: 194,
    cast: ['Leonardo DiCaprio', 'Kate Winslet'],
    imagePath: 'assets/images/titanic.jpg',
  ),
  ContentItem(
    title: 'Stranger Things',
    type: 'series',
    genres: ['Sci-Fi', 'Horror', 'Drama'],
    language: 'English',
    rating: 8.7,
    durationMins: 50,
    cast: ['Millie Bobby Brown', 'David Harbour', 'Winona Ryder'],
    imagePath: 'assets/images/stranger_things.jpg',
  ),
  ContentItem(
    title: 'Chhota Bheem',
    type: 'kids',
    genres: ['Animation', 'Adventure'],
    language: 'Hindi',
    rating: 6.5,
    durationMins: 22,
    cast: [],
    imagePath: 'assets/images/Chhota_Bheem.jpg',
  ),
  ContentItem(
    title: 'Planet Earth',
    type: 'documentary',
    genres: ['Nature', 'Documentary'],
    language: 'English',
    rating: 9.3,
    durationMins: 58,
    cast: ['David Attenborough'],
    imagePath: 'assets/images/planetEarth.jpg',
  ),
];

const kGenres = <String>{
  'Action',
  'Adventure',
  'Animation',
  'Comedy',
  'Crime',
  'Drama',
  'Fantasy',
  'Horror',
  'Romance',
  'Sci-Fi',
  'Thriller',
  'Documentary',
  'Nature',
  'Family',
};
const kLanguages = <String>{'English', 'Hindi', 'Tamil', 'Telugu'};
const kTypes = <String>{'movie', 'series', 'kids', 'documentary', 'original'};

class OttSearchPage extends StatefulWidget {
  const OttSearchPage({super.key});

  @override
  State<OttSearchPage> createState() => _OttSearchPageState();
}

class _OttSearchPageState extends State<OttSearchPage> {
  final TextEditingController _search = TextEditingController();

  final Set<String> _selectedTypes = {};
  final Set<String> _selectedGenres = {};
  final Set<String> _selectedLanguages = {};

  double _minRating = 0; // 0..10
  String _durationBucket = 'any';

  final List<String> _recentSearches = [];
  final List<String> _trending = [
    'Star Wars',
    'Romance',
    'Tamil Action',
    'Kids',
    'Documentary',
  ];

  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(
      () => setState(() => _showSuggestions = _search.text.isNotEmpty),
    );
  }

  List<ContentItem> get _results {
    String q = _normalized(_search.text.trim());

    return kCatalog.where((c) {
      if (_selectedTypes.isNotEmpty && !_selectedTypes.contains(c.type)) {
        return false;
      }

      if (_selectedGenres.isNotEmpty &&
          _selectedGenres.intersection(c.genres.toSet()).isEmpty) {
        return false;
      }

      if (_selectedLanguages.isNotEmpty &&
          !_selectedLanguages.contains(c.language)) {
        return false;
      }

      if (c.rating < _minRating) return false;

      switch (_durationBucket) {
        case 'short':
          if (!(c.durationMins < 30)) return false;
          break;
        case 'medium':
          if (!(c.durationMins >= 30 && c.durationMins <= 90)) return false;
          break;
        case 'long':
          if (!(c.durationMins > 90)) return false;
          break;
      }

      if (q.isEmpty) return true;

      return _normalized(c.title).contains(q);
    }).toList();
  }

  String _normalized(String s) {
    return s.toLowerCase();
  }

  void _submitSearch([String? term]) {
    final String query = term ?? _search.text.trim();
    if (query.isEmpty) return;
    if (_recentSearches.isEmpty || _recentSearches.first != query) {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 8) _recentSearches.removeLast();
    }
    _search.text = query;
    setState(() => _showSuggestions = false);
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return SafeArea(
      child: Column(
        children: [
          _buildSearchBar(),
          if (_showSuggestions) _buildSuggestions(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChipsSection(),
                  if (_recentSearches.isNotEmpty) _buildRecentAndTrending(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      children: [
                        Text(
                          'Results',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${results.length})',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  if (results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('No results. Try adjusting filters.'),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true, // important since inside scroll view
                      physics:
                          const NeverScrollableScrollPhysics(), //  disable nested scroll
                      itemCount: results.length,
                      itemBuilder: (context, i) =>
                          _ResultTile(item: results[i]),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _search,
              onSubmitted: (_) => _submitSearch(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search titles',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                isDense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Voice search',
            icon: const Icon(Icons.mic_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎤 Voice search coming soon…')),
              );
            },
          ),
          IconButton(
            tooltip: 'Clear filters',
            icon: const Icon(Icons.filter_alt_off_outlined),
            onPressed: () {
              setState(() {
                _selectedTypes.clear();
                _selectedGenres.clear();
                _selectedLanguages.clear();
                _minRating = 0;
                _durationBucket = 'any';
              });
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Submit',
            onPressed: _submitSearch,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final q = _search.text.trim().toLowerCase();
    final titles = kCatalog
        .map((c) => c.title)
        .where((t) => t.toLowerCase().contains(q))
        .toSet()
        .take(8)
        .toList();

    if (titles.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: titles.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final text = titles[i];
            return ListTile(
              dense: true,
              leading: Icon(Icons.movie_outlined),
              title: Text(text),
              onTap: () {
                _submitSearch(text);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildChipWrap(
    String label,
    Iterable<String> options,
    Set<String> selected, {
    bool multi = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((o) {
              final isSel = selected.contains(o);
              return FilterChip(
                label: Text(o, style: TextStyle(color: Colors.white)),
                selected: isSel,
                selectedColor: Colors.blue,
                checkmarkColor: Colors.white,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      if (!multi) selected.clear();
                      selected.add(o);
                    } else {
                      selected.remove(o);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChipWrap('Content Type', kTypes, _selectedTypes),
        _buildChipWrap('Genres', kGenres, _selectedGenres),
        _buildChipWrap('Languages', kLanguages, _selectedLanguages),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Min Rating: ${_minRating.toStringAsFixed(1)}'),
                        Slider(
                          min: 0,
                          max: 10,
                          divisions: 20,
                          value: _minRating,
                          onChanged: (v) => setState(() => _minRating = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Duration'),
                        const SizedBox(height: 8),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'any', label: Text('Any')),
                            ButtonSegment(value: 'short', label: Text('<30m')),
                            ButtonSegment(
                              value: 'medium',
                              label: Text('30–90m'),
                            ),
                            ButtonSegment(value: 'long', label: Text('>90m')),
                          ],
                          selected: {_durationBucket},
                          onSelectionChanged: (s) =>
                              setState(() => _durationBucket = s.first),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildRecentAndTrending() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent searches',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                TextButton(
                  onPressed: () => setState(_recentSearches.clear),
                  child: const Text('Clear'),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches
                  .map(
                    (s) => ActionChip(
                      label: Text(s),
                      onPressed: () => _submitSearch(s),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          Text('Trending', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trending
                .map(
                  (s) => InputChip(
                    label: Text(s),
                    onPressed: () => _submitSearch(s),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final ContentItem item;
  const _ResultTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            item.imagePath,
            width: 54,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Wrap(
              spacing: 6,
              runSpacing: -4,
              children: [
                _Pill(text: item.type),
                _Pill(text: item.language),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${item.genres.join(' • ')}\n⭐ ${item.rating.toStringAsFixed(1)}  ·  ${item.durationMins} min',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill),
          onPressed: () {},
          tooltip: 'Play',
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
