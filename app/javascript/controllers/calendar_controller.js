import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"
import interactionPlugin from "@fullcalendar/interaction"

export default class extends Controller {
  static targets = ["calendar"]
  static values = { organizationId: Number }  
  events = []

  connect() {
    console.log("Stimulus controller connected");
    this.calendar = new Calendar(this.calendarTarget, {
      plugins: [dayGridPlugin, interactionPlugin],
      editable: true,
      eventResizableFromStart: true,
      events: `/organizations/${this.organizationIdValue}/payroll_periods.json`,
      eventResize: this.eventResize.bind(this),
      eventDrop: this.eventDrop.bind(this),
      eventDidMount: this.handleEventDidMount.bind(this),
      datesSet: this.handleDatesSet.bind(this),
      dayCellDidMount: this.handleDayCellDidMount.bind(this),
      eventsSet: this.handleEventsSet.bind(this)
    })

    this.calendar.render()
  }

  handleEventsSet(events) {
    this.events = events;
    this.updateDayCells();
  }  
  
  updateDayCells() {
    const dayCells = this.calendarTarget.querySelectorAll('.fc-daygrid-day');
    dayCells.forEach(cell => {
      const date = cell.dataset.date;
      const hasEvent = this.events.some(event => {
        const eventStart = new Date(event.start).toISOString().split('T')[0];
        const eventEnd = new Date(event.end).toISOString().split('T')[0];
        return date >= eventStart && date < eventEnd;
      });

      const existingPlusIcon = cell.querySelector('.add-payroll-period-icon');
      if (!hasEvent && !existingPlusIcon) {
        this.addPlusIcon(cell, new Date(date));
      } else if (hasEvent && existingPlusIcon) {
        existingPlusIcon.remove();
      }
    });
  }

  handleDatesSet() {
    this.events = this.calendar.getEvents();
  }

  addPlusIcon(element, date) {
    const plusIcon = document.createElement('i');
    plusIcon.classList.add('bi', 'bi-plus-circle', 'add-payroll-period-icon');
    plusIcon.style.cursor = 'pointer';
    plusIcon.addEventListener('click', (e) => {
      e.stopPropagation();
      this.createPayrollPeriod(date);
    });
    element.appendChild(plusIcon);
  }

  eventResize(info) {
    this.updatePayrollPeriod(info.event)
  }

  eventDrop(info) {
    this.updatePayrollPeriod(info.event)
  }

  updatePayrollPeriod(event) {
    console.log('updatePayrollPeriod called');
    const csrfToken = document.querySelector("[name='csrf-token']").content
    const endDate = new Date(event.end);
    endDate.setDate(endDate.getDate() - 1);     
    fetch(`/organizations/${this.organizationIdValue}/payroll_periods/${event.id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        payroll_period: {
          start_date: event.start.toISOString(),
          end_date: endDate.toISOString()
        }
      })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("There was an error!")
      }
      return response.json()
    })
    .then(data => {
      this.calendar.refetchEvents();
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error)
    })
  }

  generatePayrollPeriod(event) {
    console.log('generatePayrollPeriod called');
    const periodType = event.target.dataset.period
    const startDate = document.getElementById('start-date').value;
    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(`/organizations/${this.organizationIdValue}/payroll_periods/generate_payroll_periods`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ period_type: periodType, start_date: startDate })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok")
      }
      return response.json()
    })
    .then(data => {
      console.log('Payroll periods generated:', data);
      this.calendar.refetchEvents()
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error)
    })
  }  
  generateCustomPayrollPeriods(event) {
    console.log('generateCustomPayrollPeriods called');
    const days = document.getElementById('custom-period-days').value
    const startDate = document.getElementById('start-date').value
    if (!days || days <= 0) {
      alert('Please enter a valid number of days.');
      return;
    }

    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(`/organizations/${this.organizationIdValue}/payroll_periods/generate_custom_payroll_periods`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ days: days, start_date: startDate })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok")
      }
      return response.json()
    })
    .then(data => {
      console.log('Custom payroll periods generated:', data);
      this.calendar.refetchEvents()
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error)
    })
  }  
  clearAllPayrollPeriods(event) {
    console.log('clearAllPayrollPeriods called');
    if (!confirm("Are you sure you want to delete all payroll periods?")) {
      return;
    }

    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(`/organizations/${this.organizationIdValue}/payroll_periods/clear_future_payroll_periods?all=true`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok")
      }
      return response.json()
    })
    .then(data => {
      console.log('All payroll periods cleared:', data);
      this.calendar.refetchEvents()
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error)
    })
  }  
  clearFuturePayrollPeriods(event) {
    console.log('clearFuturePayrollPeriods called');
    if (!confirm("Are you sure you want to delete all future payroll periods?")) {
      return;
    }    
    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(`/organizations/${this.organizationIdValue}/payroll_periods/clear_future_payroll_periods`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok")
      }
      return response.json()
    })
    .then(data => {
      console.log('Future payroll periods cleared:', data);
      this.calendar.refetchEvents()
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error)
    })
  }  
  handleEventDidMount(info) {
    if (info.isEnd) {
      const closeIcon = document.createElement('i');
      closeIcon.classList.add('bi', 'bi-x-circle', 'event-end-marker');
      closeIcon.style.cursor = 'pointer';
      closeIcon.style.float = 'right';
      closeIcon.style.marginLeft = '10px';
      closeIcon.addEventListener('click', (e) => {
        e.stopPropagation();
        if (confirm("Are you sure you want to delete this payroll period?")) {
          this.deletePayrollPeriod(info.event)
        }
      })            
      info.el.querySelector('.fc-event-main').appendChild(closeIcon);
    }    
  }  
  handleDayCellDidMount(info) {
    const hasEvent = this.events.some(event => {
      const eventStart = new Date(event.start).toISOString().split('T')[0];
      const eventEnd = new Date(event.end).toISOString().split('T')[0];
      const day = new Date(info.date).toISOString().split('T')[0];
      return day >= eventStart && day < eventEnd;
    });
    if (!hasEvent) {
      this.addPlusIcon(info.el, info.date);
    }
  }  
  createPayrollPeriod(date) {
    console.log('createPayrollPeriod called');
    const csrfToken = document.querySelector("[name='csrf-token']").content

    fetch(`/organizations/${this.organizationIdValue}/payroll_periods`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        payroll_period: {
          start_date: date.toISOString(),
          end_date: date.toISOString()
        }
      })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("There was an error!")
      }
      return response.json()
    })
    .then(data => {
      console.log('Payroll period created:', data);
      this.calendar.refetchEvents()
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error)
    })
  }  
  deletePayrollPeriod(event) {
    console.log('deletePayrollPeriod called');
    const csrfToken = document.querySelector("[name='csrf-token']").content
    fetch(`/organizations/${this.organizationIdValue}/payroll_periods/${event.id}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok")
      }
      return response.json()
    })
    .then(data => {
      console.log('Payroll period deleted:', data);
      this.calendar.refetchEvents()
    })
    .catch(error => {
      console.error("There was a problem with the fetch operation:", error)
    })
  }  
}
