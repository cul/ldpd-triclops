import React, {useRef} from 'react';

// const STATUSES = [1, 2, 3, 4];

export default function SearchBar({filterChoices, filterDefault, searchDefault, onSearch, onFilter}) {
  const identifierInput = useRef();

  return (
    <div>
      <p>
        <label>Filter by status: </label>
        <select name="status" value={filterDefault} onChange={(event) => {return onFilter(event.target.value)}}>
          <option key={-1} value={'Any'}>Any</option> 
          {filterChoices.map((status) => {
            return <option key={filterChoices.indexOf(status)} value={status + ''}>{status}</option>
          })}
        </select>
        <label> </label>
        <label>Search for Identifier: </label>
        <input ref={identifierInput} defaultValue={searchDefault}/>
        <label> </label>
        <button onClick={() => onSearch(identifierInput.current.value)}>search</button>
      </p>
    </div>
  )
}