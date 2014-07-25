From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Fri, 25 Jul 2014 16:54:32 -0700
Message-ID: <CALCETrUqkRx5yDgbKJSD61E-xkjOYoOL+yrZdWxG-hb8j-mQcQ@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
 <53D2EB98.3090802@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <53D2EB98.3090802@zytor.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 4:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/25/2014 11:30 AM, Andy Lutomirski wrote:
>>     - 32-bit GDT code segments [huge attack surface]
>>     - 64-bit GDT code segments [probably pointless]
>
> I presume you mean s/GDT/LDT/.
>
> We already don't allow 64-bit LDT code segments.  Also, it is unclear to
> me how 32-bit LDT segments have a huge attack surface, given that there
> will realistically always be a 32-bit *GDT* segment present.

I really did mean GDT :)  Setting the 32-bit code segment to "not
present" (and using seccomp to block modify_ldt) prevents any attempt
to exploit bugs in the sysenter and cstar code.  It also might prevent
exploiting CPU bugs, although I've never heard of a relevant CPU bug
in this area.

If I actually tried to implement this (which wouldn't be part of the
initial implementation), I'd split out the unusual things in
__switch_to and friends to a slow path that's only used if weird
settings are present (e.g. this, TSC restrictions, etc).  But
twiddling the present bit on a GDT entry is very fast, I assume --
it's just memory, and I don't think that any flush is needed.

Also, if I implement this, I will curse Xen.  I might even go so far
as to disable the feature entirely if there's a paravirt GDT.

Hmm.  A separate flag to turn int $0x80 into GPF could have some value, too.

--Andy
