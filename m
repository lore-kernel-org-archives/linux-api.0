From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 1/2] fork: add clone6
Date: Tue, 28 May 2019 10:23:21 -0500
Message-ID: <87ef4i7gd2.fsf@xmission.com>
References: <20190526102612.6970-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190526102612.6970-1-christian@brauner.io> (Christian Brauner's
        message of "Sun, 26 May 2019 12:26:11 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jannh@google.com, fweimer@redhat.com, oleg@redhat.com, arnd@arndb.de, dhowells@redhat.com, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> writes:

> This adds the clone6 system call.
>
> As mentioned several times already (cf. [7], [8]) here's the promised
> patchset for clone6().
>
> We recently merged the CLONE_PIDFD patchset (cf. [1]). It took the last
> free flag from clone().
>
> Independent of the CLONE_PIDFD patchset a time namespace has been discussed
> at Linux Plumber Conference last year and has been sent out and reviewed
> (cf. [5]). It is expected that it will go upstream in the not too distant
> future. However, it relies on the addition of the CLONE_NEWTIME flag to
> clone(). The only other good candidate - CLONE_DETACHED - is currently not
> recycable as we have identified at least two large or widely used codebases
> that currently pass this flag (cf. [2], [3], and [4]). Given that we
> grabbed the last clone() flag we effectively blocked the time namespace
> patchset. It just seems right that we unblock it again.

I am not certain just extending clone is the right way to go.

- Last I looked glibc does not support calling clone without creating
  a stack first.  Which makes it unpleasant to support clone as a fork
  with extra flags as container runtimes would appreciate.

- Tying namespace creation to process creation is unnecessary.
  I admit both the time and the pid namespace actually need a new
  process before you can use them, but the trick of having a namespace
  for children and a namespace the current process uses seems to handle
  that case nicely.

- There is cruft in clone current runtimes do not use.
  The entire CSIGNAL mask. Also: CLONE_PARENT, CLONE_DETACHED.  And
  probably one or two other bits that I am not remembering right now.

  It would probably make sense to make all of the old linux-thread
  support optional so we can compile it out, and in a decade or two
  get rid of it as unused code.

Maybe some of this is time critical and doing everything in a single
system call makes sense.  But I don't a few extra microseconds matters
in container creation.  It feels to me like the road to better
maintenance of the kernel would just be to move work out of clone.

It certainly feels like we could implement all of the current
clone functionality on top of a simpler clone that I have described.

Perhaps we want sys_createns that like setns works on a single
namespace at a time.

Eric
