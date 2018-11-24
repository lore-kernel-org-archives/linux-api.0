From: David Newall <glibc@davidnewall.com>
Subject: Re: Official Linux system wrapper library?
Date: Sat, 24 Nov 2018 14:11:38 +1030
Message-ID: <98843299-f064-8582-76d8-46217de2626f@davidnewall.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com>
 <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <87efbbvrx9.fsf@oldenburg.str.redhat.com>
 <a50dbc52-b5e8-6684-508d-b96ad8d70d4f@davidnewall.com>
 <b0c3ecce-c4d0-246d-d702-21674f950e34@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-97519-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <b0c3ecce-c4d0-246d-d702-21674f950e34@arm.com>
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Florian Weimer <fweimer@redhat.com>, Daniel Colascione <dancol@google.com>
Cc: nd <nd@arm.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 24/11/18 1:53 am, Szabolcs Nagy wrote:
> On 23/11/18 14:11, David Newall wrote:
>> On 24/11/18 12:04 am, Florian Weimer wrote:
>>> But socketcall does not exist on all architectures.  Neither does
>>> getpid, it's called getxpid on some architectures.
>>> ...
>>> I think it would be a poor approach to expose application developers to
>>> these portability issues.  We need to abstract over these differences at
>>> a certain layer, and applications are too late.
>> Interesting.  I think the opposite.  I think exposing the OS's interfaces is exactly what a c-library should do.  It might also provide
>> alternative interfaces that work consistently across different platforms, but in addition to, not instead of the OS interface.
> you don't understand the point of the c language if you think so.

I understand the point of C, thank you very much, and we're talking 
about the C library, not the language.  I don't understand the point of 
your rudeness.
