From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Official Linux system wrapper library?
Date: Fri, 16 Nov 2018 21:24:50 +0000
Message-ID: <20181116212450.1a9c43ce@alans-desktop>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
	<bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
	<20181111081725.GA30248@1wt.eu>
	<3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
	<20181111111143.GB4189@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-97325-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20181111111143.GB4189@1wt.eu>
To: Willy Tarreau <w@1wt.eu>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Florian Weimer <fweimer@redhat.com>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org


> I think the issue is a bit more complex :
>   - linux doesn't support a single libc
>   - glibc doesn't support a single OS
> 
> In practice we all know (believe?) that both statements above are
> true but in practice 99% of the time there's a 1:1 relation between
> these two components. 

The top linux C library is probably the Android one. Given the number
of containers now running Alpine and the number of embedded devices it's
probably a good fight going on for 2nd, 3rd and 4th. It is certainly not
a Linux/Glibc world any more.

Alan
