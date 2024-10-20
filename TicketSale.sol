// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TicketSale {
    struct Ticket {
        uint id;
        address owner;
        uint price;
        bool isForSale;
    }

    mapping(uint => Ticket) public tickets;
    uint public ticketCount;

    event TicketCreated(uint id, uint price);
    event TicketBought(uint id, address buyer, uint price);

    function createTicket(uint price) public {
        ticketCount++;
        tickets[ticketCount] = Ticket(ticketCount, msg.sender, price, true);
        emit TicketCreated(ticketCount, price);
    }

    function buyTicket(uint id) public payable {
        Ticket storage ticket = tickets[id];
        require(ticket.isForSale, "Ticket not for sale");
        require(msg.value >= ticket.price, "Insufficient funds");

        address previousOwner = ticket.owner;
        ticket.owner = msg.sender;
        ticket.isForSale = false;

        payable(previousOwner).transfer(msg.value);
        emit TicketBought(id, msg.sender, msg.value);
    }

    function getTicket(uint id) public view returns (uint, address, uint, bool) {
        Ticket memory ticket = tickets[id];
        return (ticket.id, ticket.owner, ticket.price, ticket.isForSale);
    }
}
