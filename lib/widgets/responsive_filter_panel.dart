import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

/// A responsive filter panel that adapts its layout based on screen size.
///
/// On mobile (< 600px): Displays filters in a vertical stack with collapsible section for > 3 filters
/// On desktop (>= 600px): Displays filters in a horizontal row
class ResponsiveFilterPanel extends StatefulWidget {
  /// The search field widget (typically a TextField)
  final Widget searchField;

  /// List of filter widgets (typically DropdownButtons or similar)
  final List<Widget> filters;

  /// Whether to enable collapsible behavior for mobile when > 3 filters
  final bool collapsible;

  /// Optional callback when filters are cleared
  final VoidCallback? onClearFilters;

  /// Whether any filters are currently active
  final bool hasActiveFilters;

  const ResponsiveFilterPanel({
    super.key,
    required this.searchField,
    required this.filters,
    this.collapsible = true,
    this.onClearFilters,
    this.hasActiveFilters = false,
  });

  @override
  State<ResponsiveFilterPanel> createState() => _ResponsiveFilterPanelState();
}

class _ResponsiveFilterPanelState extends State<ResponsiveFilterPanel> {
  bool _filtersExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
  }

  Widget _buildMobileLayout() {
    final shouldCollapse = widget.collapsible && widget.filters.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search field at full width
        widget.searchField,
        const SizedBox(height: AppSpacing.mobileFilterSpacing),

        // Filters
        if (shouldCollapse)
          _buildCollapsibleFilters()
        else
          ..._buildFilterList(),

        // Clear filters button if filters are active
        if (widget.hasActiveFilters && widget.onClearFilters != null) ...[
          const SizedBox(height: AppSpacing.mobileFilterSpacing),
          _buildClearFiltersButton(),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search field
        widget.searchField,
        const SizedBox(height: 12),

        // Filters in horizontal row
        if (widget.filters.isNotEmpty)
          Row(
            children: [
              ...widget.filters.map(
                (filter) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: filter,
                  ),
                ),
              ),
            ],
          ),

        // Clear filters button if filters are active
        if (widget.hasActiveFilters && widget.onClearFilters != null) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _buildClearFiltersButton(),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildFilterList() {
    return widget.filters.map((filter) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.mobileFilterSpacing),
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
          child: filter,
        ),
      );
    }).toList();
  }

  Widget _buildCollapsibleFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Show first 3 filters always
        ...widget.filters.take(3).map(
              (filter) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.mobileFilterSpacing,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppSpacing.minTouchTarget,
                  ),
                  child: filter,
                ),
              ),
            ),

        // Expand/collapse button
        InkWell(
          onTap: () {
            setState(() {
              _filtersExpanded = !_filtersExpanded;
            });
          },
          child: Container(
            height: AppSpacing.minTouchTarget,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _filtersExpanded ? 'Show Less Filters' : 'Show More Filters',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: AppTypography.mobileBodyText,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _filtersExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).primaryColor,
                  size: AppIconSizes.button,
                ),
              ],
            ),
          ),
        ),

        // Additional filters when expanded
        if (_filtersExpanded) ...[
          const SizedBox(height: AppSpacing.mobileFilterSpacing),
          ...widget.filters.skip(3).map(
                (filter) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.mobileFilterSpacing,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppSpacing.minTouchTarget,
                    ),
                    child: filter,
                  ),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildClearFiltersButton() {
    return SizedBox(
      height: AppSpacing.minButtonHeight,
      child: OutlinedButton.icon(
        onPressed: widget.onClearFilters,
        icon: const Icon(Icons.clear, size: AppIconSizes.button),
        label: const Text('Clear Filters'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            AppSpacing.minTouchTarget,
            AppSpacing.minButtonHeight,
          ),
        ),
      ),
    );
  }
}
