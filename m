From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 7 Nov 2019 13:02:18 -0500
Message-ID: <bc1d29f7-0990-b52f-7a5b-f4faf722fe16@redhat.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
 <0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
 <87zhh7j38y.fsf@oldenburg2.str.redhat.com>
 <CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
 <87zhh7hlbl.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-106779-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87zhh7hlbl.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>, Elichai Turkel <elichai.turkel@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/7/19 8:23 AM, Florian Weimer wrote:
> Officially, it's supposed to work today.  We have one glibc developer
> who says that it's easy to solve, but I disagree strongly.  The fact
> that the problems are not fixed promptly suggests that it's anything but
> simple.

Is that one glibc developer me? :-)

They aren't easy to solve, but there is a magic process in place.

Getting the definitions to line up is part of the work involved.

Sometimes they may not line up, in that case it doesn't work.

> What I've been doing instead is to include UAPI headers directly from
> glibc headers if it's technically feasible.  (It's not possible in POSIX
> mode, where we have to manage the set of exported symbols closely, or
> generally with old compilers which do not have __has_include.)  See
> <bits/statx.h>, <bits/statx-generic.h> etc. in current glibc for an
> example.

That's really the best way to solve it if you can.

> If you add more type definitions to kernel headers, this might interfere
> with such usage of UAPI headers because today, we need to provide our
> own definitions for many things not in UAPI headers, and the currently
> deployed glibc headers are simply not compatible with such future
> changes.

Right.

-- 
Cheers,
Carlos.
