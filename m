From: Elichai Turkel <elichai.turkel@gmail.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 7 Nov 2019 15:03:12 +0200
Message-ID: <CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
 <0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com> <87zhh7j38y.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-106748-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87zhh7j38y.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 7, 2019 at 2:10 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> The kernel uses some POSIX names with POSIX-incompatible definitions,
> e.g. struct msghdr.  Some libcs prioritize POSIX conformance over kernel
> conformance and implement userspace translation for mismatch types.
> When building against such libcs, it becomes difficult to use UAPI and
> libc headers in a single translation unit.  (It is already difficult
> today in some cases.)
>
> I don't know a good solution here.  Not using POSIX names in UAPI
> headers is one option.  Previously, we have tried to use preprocessor
> macros to coordinate definitions, but did not work well in practice
> (only few conflicts were ever resolved).  It does not help at all when
> the definitions are incompatible.
>
> Thanks,
> Florian
>

Thanks for the response,
I'm not sure what are you suggesting exactly.
A rename to the structs/types so they won't collide with libc?
Prioritizing POSIX conformance in the kernel(I think that ship has long sailed)?
Or just giving up and telling users they can't just directly include
both libc headers and kernel headers?
(I'm actually not sure how it works now. because there are definitely
collision and if we are using ifdefs and undefs black magic you still
end up with a single declaration in the end that might not be
compatible with both libc and kernel)

I'd personally really like to see a better separation between (g)libc
and the kernel. I

Thanks,
Elichai.

-- 
PGP: 5607C93B5F86650C
