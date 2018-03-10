From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Sat, 10 Mar 2018 15:16:52 +0000
Message-ID: <20180310151652.GV4449@wotan.suse.de>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
 <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
 <20180309.135724.452219538059491199.davem@davemloft.net>
 <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
 <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
 <81b7599d-aab7-6cb6-7843-64510c8f6260@fb.com>
 <20180310140843.GP4449@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180310140843.GP4449@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>, Jessica Yu <jeyu@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Djalal Harouni <tixxdz@gmail.com>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 10, 2018 at 02:08:43PM +0000, Luis R. Rodriguez wrote:
> The alternative to this would be a simple equivalent of try_then_request_module()
> for UMH modules: try_umhm_then_request_umh_module() or whatever. So just as I
> argued earlier over UMH limitations, this is not the end of the world for umh
> modules, and it doesn't mean you can't get *properly* add umh modules upstream,
> it would *just mean* we'd be perpetuating today's (IMHO) horrible and loose
> semantics.

I was about to suggest that perhaps a try_umhm_then_request_umh_module() or
whatever should not be a macro -- but instead an actual routine, and we don't
export say the simple form to avoid non-deterministic uses of it from the
start... but the thing is *it'd have to be a macro* given that the *check* for
the module *has to be loose*, just as try_then_request_module()...

*Ugh* gross.

Another reason for me to want an actual deterministic clean proper solution
from the start.

  Luis
