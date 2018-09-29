// User.jsx

import React from "react";

export default class User extends React.PureComponent {
  render() {
    const { name, onDeleteClick, id } = this.props;
    return (
      <li>
        <input type="button" value="Delete" onClick={onDeleteClick} />
        {name}
      </li>
    );
  }
}
