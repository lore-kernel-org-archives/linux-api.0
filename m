From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 07 Nov 2019 13:05:16 +0100
Message-ID: <0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-106746-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
To: Elichai Turkel <elichai.turkel@gmail.com>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org

[+Cc Florian, glibc]

On November 7, 2019 12:17:50 PM GMT+01:00, Elichai Turkel <elichai=2Eturke=
l@gmail=2Ecom> wrote:
>Hi,
>I'm working on a library that calls syscalls directly to the kernel=2E
>`make hedears_install` is a great command to auto generate the UAPI
>headers that are needed to call the kernel=2E
>
>But the headers are still missing a bunch of defines for flags and
>structs=2E
>
>I wanted to know if patches to move more things from `=2E/include/linux`
>to `=2E/include/uapi/linux` are welcome (obviously only
>typedefs/defines/structs that are required for the syscalls)
>
>I think the UAPI is really close to getting a complete set of things
>needed to communicate with the syscalls, but still not quite there=2E I
>would like to push patches whenever I see missing things that my
>library needs (that way it will be incrementally and by usage only)=2E
>
>Would love to get feedback=2E
>Thanks,
>Elichai=2E
