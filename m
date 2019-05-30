From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Date: Thu, 30 May 2019 15:29:00 -0600
Message-ID: <20190530212900.GC5739@cisco>
References: <cover.1554732921.git.rgb@redhat.com>
	<9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
	<20190529145742.GA8959@cisco>
	<CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
	<20190529153427.GB8959@cisco>
	<CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
	<20190529222835.GD8959@cisco>
	<CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
	<20190530170913.GA16722@mail.hallyn.com>
	<CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Paul Moore <paul@paul-moore.com>
Cc: nhorman@tuxdriver.com, Richard Guy Briggs <rgb@redhat.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 30, 2019 at 03:29:32PM -0400, Paul Moore wrote:
> 
> [REMINDER: It is an "*audit* container ID" and not a general
> "container ID" ;)  Smiley aside, I'm not kidding about that part.]

This sort of seems like a distinction without a difference; presumably
audit is going to want to differentiate between everything that people
in userspace call a container. So you'll have to support all this
insanity anyway, even if it's "not a container ID".

> I'm not interested in supporting/merging something that isn't useful;
> if this doesn't work for your use case then we need to figure out what
> would work.  It sounds like nested containers are much more common in
> the lxc world, can you elaborate a bit more on this?
> 
> As far as the possible solutions you mention above, I'm not sure I
> like the per-userns audit container IDs, I'd much rather just emit the
> necessary tracking information via the audit record stream and let the
> log analysis tools figure it out.  However, the bigger question is how
> to limit (re)setting the audit container ID when you are in a non-init
> userns.  For reasons already mentioned, using capable() is a non
> starter for everything but the initial userns, and using ns_capable()
> is equally poor as it essentially allows any userns the ability to
> munge it's audit container ID (obviously not good).  It appears we
> need a different method for controlling access to the audit container
> ID.

One option would be to make it a string, and have it be append only.
That should be safe with no checks.

I know there was a long thread about what type to make this thing. I
think you could accomplish the append-only-ness with a u64 if you had
some rule about only allowing setting lower order bits than those that
are already set. With 4 bits for simplicity:

1100         # initial container id
1100 -> 1011 # not allowed
1100 -> 1101 # allowed, but now 1101 is set in stone since there are
             # no lower order bits left

There are probably fancier ways to do it if you actually understand
math :)

Since userns nesting is limited to 32 levels (right now, IIRC), and
you have 64 bits, this might be reasonable. You could just teach
container engines to use the first say N bits for themselves, with a 1
bit for the barrier at the end.

Tycho
