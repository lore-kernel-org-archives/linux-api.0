From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Continuing the UAPI split
Date: Thu, 07 Nov 2019 21:32:05 +0100
Message-ID: <875zjvo2be.fsf@mid.deneb.enyo.de>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
	<0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
	<87zhh7j38y.fsf@oldenburg2.str.redhat.com>
	<CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
	<facb4d0d-4e20-41f0-4c01-b210c677c24c@arm.com>
	<086ffddf-553f-453d-a046-4d5e6abead21@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-106787-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <086ffddf-553f-453d-a046-4d5e6abead21@redhat.com> (Carlos
	O'Donell's message of "Thu, 7 Nov 2019 13:05:19 -0500")
To: Carlos O'Donell <carlos@redhat.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Elichai Turkel <elichai.turkel@gmail.com>, nd <nd@arm.com>, Christian Brauner <christian.brauner@ubuntu.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Carlos O'Donell:

> On 11/7/19 11:21 AM, Szabolcs Nagy wrote:
>>> Or just giving up and telling users they can't just directly include
>>> both libc headers and kernel headers?
>> 
>> including both libc and linux headers is fragile and
>> will break differently across the different linux
>> libc implementations.
>
> We saw this all the time working in embedded.

Do you mean you saw problems while you working in the embedded space?
