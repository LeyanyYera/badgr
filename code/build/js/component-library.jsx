var React = require('react');
var PatternItem = require('react-style-guide');

var FixedDataTable = require('fixed-data-table');
var Table = FixedDataTable.Table;
var Column = FixedDataTable.Column;

var BadgeSelectionTable = require('./components/BadgeSelectionTable.jsx').BadgeSelectionTable;

var dummyBadges = [
    {}, {}, {}, {}
];

var ReactPatterns = React.createClass({
    /* BadgeSelectionTable: Used in the earner's collection management dialog */
    badgeSelectionTable: function(){
        return (
            <PatternItem
                title="BadgeSelectionTable"
                description="A list of selectable badges in tabular format"
            >
                <BadgeSelectionTable
                    badges={dummyBadges}
                />
            </PatternItem>
        );
    },


    render: function(){
        return (
            <div className="reactpatterns">
                {this.badgeSelectionTable()}
            </div>
        );
    }
});


React.render(
    <ReactPatterns />,
    document.getElementById('ReactPatterns')
);