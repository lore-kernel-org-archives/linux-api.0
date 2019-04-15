From: hpa@zytor.com
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Mon, 15 Apr 2019 08:54:28 -0700
Message-ID: <60CC2FAD-CCFF-4550-AAF6-40B059BF88C7@zytor.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com> <EF5CE34B-1A82-4391-B07E-DB832814AD1C@zytor.com> <87r2aaz74f.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-101393-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87r2aaz74f.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: libc-alpha@sourceware.org, adhemerval.zanella@linaro.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On April 9, 2019 11:50:24 PM PDT, Florian Weimer <fweimer@redhat=2Ecom> wro=
te:
>* hpa:
>
>> PowerPC doesn't need it at all=2E
>
>Because the definition would be the same as struct termios?
>
>I think we should still define struct termios2 using the struct termios
>definition, and also define TCGETS2 and TCSETS2=2E  This way,
>applications
>can use the struct termios2 type without affecting portability to
>POWER=2E
>
>Thanks,
>Florian

Agreed=2E There is just no reason to have a new set of ioctl numbers for P=
owerPC; just make them aliases=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
