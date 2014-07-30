From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
Date: Wed, 30 Jul 2014 07:51:17 -0700
Message-ID: <CALCETrXANJQn_X=Okm+WnB0Bq__xXg3f4em01q1Uzkgh7m5DNQ@mail.gmail.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
 <871tt796i0.fsf@x220.int.ebiederm.org> <CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA@mail.gmail.com>
 <87ha21qja0.fsf@x220.int.ebiederm.org> <CAHse=S_w4+AMuc=-XbAK_PiaD56_ks13R53RENMHif5KRN_Kiw@mail.gmail.com>
 <87iomfgyd2.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <87iomfgyd2.fsf@x220.int.ebiederm.org>
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

On Jul 29, 2014 11:25 PM, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
>
> I have cut this down to just focus on O_BENEATH openat case.
>
> David Drysdale <drysdale@google.com> writes:
>
> > On Mon, Jul 28, 2014 at 10:13 PM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
>
> >> Nope.  What you can implement today if you want fine grained limitations
> >> like this is to create a mount namespace with exactly the subdirectory
> >> tree you want to allow access to and to return a file descriptor that
> >> points into that mount namespace.  (When complete the only user of that
> >> mount namespace would be your file descriptor).
> >
> > How does that solve the particular example I mentioned?  The DFD
> > within the mount namespace will still allow any operation on any file
> > that's already in the subdirectory -- or am I misunderstanding
> > something?
>
> The goal was to bound the DFD to the directory and all of it's
> subdirectories such that openat(dfd, "../../..") would open
> the dfd, and that further opens of other directories would also not
> allow you to escape.
>
> Since the mount namespace only contains the choosen directory and it's
> subdirectories that works easily and trivially.
>
> So while you can indeed perform any file operation on that dfd who
> cares because none of those operations can get you anywhere you aren't
> supposed to be.
>
> My point was that you can as granular as you would like by binding a dfd
> to a mount namespace instead of binding a process to a mount namespace,
> and the code already exists and is being maintained.
>
> So while things are not packaged in the form that has been requested it
> looks to me as if the functionality for directories already exists
> within the Linux kernel.

I think this would be amazingly expensive -- every constrained fd
would need to carry an entire mount namespace with it.  That namespace
might need to have shared recursive mounts under it.  And dfds created
for subdirectories would need yet another mount namespace.  And all
these mount namespaces would probably need user namespaces to go along
with them.

It would also have odd semantics.  If you have a dfd pointing to /foo,
and /foo/link is a symlink to "../bar", then looking up "link"
relative to /foo should fail; it should not try to resolve /foo/bar.

IOW I think this is impractical.

>
> Eric
