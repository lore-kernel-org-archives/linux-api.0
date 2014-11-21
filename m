From: Harald Hoyer <harald.hoyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Fri, 21 Nov 2014 09:14:28 +0100
Message-ID: <546EF464.5060109@gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-10-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416546149-24799-10-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 21.11.2014 06:02, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> 
> Add the logic to handle the following entities:
> 
> Domain:
>   A domain is an unamed object containing a number of buses. A
>   domain is automatically created when an instance of kdbusfs
>   is mounted, and destroyed when it is unmounted.
>   Every domain offers its own "control" device node to create
>   buses.  Domains have no connection to each other and cannot
>   see nor talk to each other.
> 
> Bus:
>   A bus is a named object inside a domain. Clients exchange messages
>   over a bus. Multiple buses themselves have no connection to each
>   other; messages can only be exchanged on the same bus. The default
>   entry point to a bus, where clients establish the connection to, is
>   the "bus" device node /dev/kdbus/<bus name>/bus.  Common operating
>   system setups create one "system bus" per system, and one "user
>   bus" for every logged-in user. Applications or services may create
>   their own private named buses.

might need a resync with the documentation.

Bus:
  A bus is a named object inside a domain. Clients exchange messages
  over a bus. Multiple buses themselves have no connection to each other;
  messages can only be exchanged on the same bus. The default entry point to
  a bus, where clients establish the connection to, is the "bus" file
  /sys/fs/kdbus/<bus name>/bus.
  Common operating system setups create one "system bus" per system, and one
  "user bus" for every logged-in user. Applications or services may create
   their own private named buses. See section 5 for more details.
