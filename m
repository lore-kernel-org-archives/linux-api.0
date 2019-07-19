From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Date: Fri, 19 Jul 2019 11:00:24 -0500
Message-ID: <87muhadnfr.fsf@xmission.com>
References: <20190529153427.GB8959@cisco>
        <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
        <20190529222835.GD8959@cisco>
        <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
        <20190530170913.GA16722@mail.hallyn.com>
        <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
        <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
        <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
        <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
        <CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
        <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca>
        <CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
        (Paul Moore's message of "Thu, 18 Jul 2019 17:52:58 -0400")
Sender: netdev-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Tycho Andersen <tycho@tycho.ws>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Wed, Jul 17, 2019 at 8:52 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> On 2019-07-16 19:30, Paul Moore wrote:
>
> ...
>
>> > We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
>> > ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).
>>
>> Ok.  So does a process in a non-init user namespace have two (or more)
>> sets of capabilities stored in creds, one in the init_user_ns, and one
>> in current_user_ns?  Or does it get stripped of all its capabilities in
>> init_user_ns once it has its own set in current_user_ns?  If the former,
>> then we can use capable().  If the latter, we need another mechanism, as
>> you have suggested might be needed.
>
> Unfortunately I think the problem is that ultimately we need to allow
> any container orchestrator that has been given privileges to manage
> the audit container ID to also grant that privilege to any of the
> child process/containers it manages.  I don't believe we can do that
> with capabilities based on the code I've looked at, and the
> discussions I've had, but if you find a way I would leave to hear it.

>> If some random unprivileged user wants to fire up a container
>> orchestrator/engine in his own user namespace, then audit needs to be
>> namespaced.  Can we safely discard this scenario for now?
>
> I think the only time we want to allow a container orchestrator to
> manage the audit container ID is if it has been granted that privilege
> by someone who has that privilege already.  In the zero-container, or
> single-level of containers, case this is relatively easy, and we can
> accomplish it using CAP_AUDIT_CONTROL as the privilege.  If we start
> nesting container orchestrators it becomes more complicated as we need
> to be able to support granting and inheriting this privilege in a
> manner; this is why I suggested a new mechanism *may* be necessary.


Let me segway a bit and see if I can get this conversation out of the
rut it seems to have drifted into.

Unprivileged containers and nested containers exist today and are going
to become increasingly common.  Let that be a given.

As I recall the interesting thing for audit to log is actions by
privileged processes.  Audit can log more but generally configuring
logging by of the actions of unprivileged users is effectively a self
DOS.

So I think the initial implementation can safely ignore actions of
nested containers and unprivileged containers because you don't care
about their actions. 

If we start allow running audit in a container then we need to deal with
all of the nesting issues but until then I don't think you folks care.

Or am I wrong.  Do the requirements for securely auditing things from
the kernel care about the actions of unprivileged users?

Eric
