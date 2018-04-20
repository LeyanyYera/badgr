var React = require('react');

var TetherTarget = require('../components/Tether.jsx').TetherTarget;


var Title = React.createClass({
    getDefaultProps: function() {
        return {
            title: "Title",
            subtitle: undefined,
            options: undefined,
            centered: false,
            truncate: true,
        };
    },

    render: function() {
        var headerClassList = [];
        if (this.props.centered) headerClassList.push('title_-x-centered');
        if (this.props.truncate) headerClassList.push('truncate_');

        var title = this.props.subtitle ?
            (<div>
                <h1 className="title_-x-primary truncate_">{this.props.title}</h1>
                <p className="title_-x-secondary truncate_">{this.props.subtitle}</p>
             </div>) :
            (<div>
                <h1 className={headerClassList.join(' ')}>{this.props.title}</h1>
             </div>);
        var options = this.props.options ? (
            <div>
                <button className="icon_ icon_-notext icon_-right icon_-more">Options</button>
            </div>) : "";
        return (
            <div className="title_">
                {title}
                {options}
            </div>);
    }
});


More = React.createClass({
    handleClick: function(ev) {
        this.refs.TetherTarget.tethered.domNode.querySelector('.dropdown_').classList.add('is-active');
        this.refs.TetherTarget.tethered.tether.position();
        this.refs.TetherTarget.tethered.domNode.querySelector('.dropdown_').classList.add('is-visible', 'is-tethered');
    },

    render: function() {
        var tetherOptions = {
            attachment: 'top right',
            targetAttachment: 'top right',
        };

        return (
            <TetherTarget ref="TetherTarget" tethered={this.props.children} tetherOptions={tetherOptions} onClick={this.handleClick}>
                <button className="icon_ icon_-notext icon_-right icon_-more">Options</button>
            </TetherTarget>
        );
    }
});


module.exports = {
    Title: Title,
    More: More,
};
