var React = require('react');
var OpenBadge = require('../components/BadgeDisplay.jsx').OpenBadge;
var EmptyOpenBadge = require('../components/BadgeDisplay.jsx').EmptyOpenBadge;
var APIStore = require('../stores/APIStore');

var OpenBadgeList = React.createClass({
  /*
  this.props.badgeList = [
    {
            "recipient_id": "nate@ottonomy.net",
            "id": 8,
            "json": {
                "id": "https://app.achievery.com/badge-assertion/4613",
                "type": "Assertion",
                "uid": {
                    "type": "xsd:string",
                    "@value": "4613"
                },
                ...
            },
            "errors": []
        }
    ],
  ]
  */
  getDefaultProps: function() {
    return {
      badges: [],
      grid: true,
      clickEmptyBadge: function(){},
      showEmptyBadge: false,
    };
  },
    render: function() {

        //var badgesInList = this.props.badgeList.map(function(item, i){
        var badgesInList = this.props.badges.map(function(item, i) {
            var badge = (
                <OpenBadge
                    key={"key-" + item['id']}
                    id={item['id']}
                    display={this.props.display || "thumbnail"}
                    json={item['json']}
                    recipientId={item['recipient_id']}
                    errors={item['errors']}
                    clickable={this.props.clickable}
                    handleClick={this.props.handleClick}
                    type={item.type || 'earned badge'}
                    />);

            if (this.props.grid) {
                return (
                    <div>
                        {badge}
                    </div>
                );
            }
            else {
                return badge;
            }
        }.bind(this));

        if (this.props.badges.length == 0 && this.props.showEmptyBadge){
            badgesInList = <EmptyOpenBadge clickEmptyBadge={this.props.clickEmptyBadge} />
        }

        return (
            <div className={ (this.props.grid) ? "l-grid" : "x-owner" }>
                { badgesInList }
            </div>
        );
    }
});

// Export the Menu class for rendering:
module.exports = OpenBadgeList;
