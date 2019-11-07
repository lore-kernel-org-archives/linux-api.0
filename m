From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 7 Nov 2019 13:05:19 -0500
Message-ID: <086ffddf-553f-453d-a046-4d5e6abead21@redhat.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
 <0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
 <87zhh7j38y.fsf@oldenburg2.str.redhat.com>
 <CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
 <facb4d0d-4e20-41f0-4c01-b210c677c24c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-106780-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <facb4d0d-4e20-41f0-4c01-b210c677c24c@arm.com>
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Elichai Turkel <elichai.turkel@gmail.com>, Florian Weimer <fweimer@redhat.com>
Cc: nd <nd@arm.com>, Christian Brauner <christian.brauner@ubuntu.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/7/19 11:21 AM, Szabolcs Nagy wrote:
>> Or just giving up and telling users they can't just directly include
>> both libc headers and kernel headers?
> 
> including both libc and linux headers is fragile and
> will break differently across the different linux
> libc implementations.

We saw this all the time working in embedded.

There ends up being a rather tight version coupling that
happens, and that's unfortunate, but a function of cost.

Fixing this so it works in the various cases is costly.

-- 
Cheers,
Carlos.
