From: Paul Eggert <eggert@cs.ucla.edu>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 17:44:52 -0800
Message-ID: <11149279-14f7-68b4-dc5e-d90924d40d0c@cs.ucla.edu>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-97147-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
To: Daniel Colascione <dancol@google.com>, Florian Weimer <fweimer@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

Daniel Colascione wrote:
> This resistance to exposing the capabilities of
> the system as they are, even in flawed and warty form, is what I meant
> by "misplaced idealism" in my previous message.

With my application-developer hat on I prefer some resistance to flaws and 
warts, as the resistance gives me a better feel for which functions are 
problematic and which can be used more reliably. If glibc is missing Linux 
syscall functionality that I really need then I can use syscall (with the usual 
caveats) and I've done that on occasion (and have regretted it later too :-). It 
is helpful for glibc to prefer mild curation to slavishly copying an API that 
can be a bit helter-skelter at times.
