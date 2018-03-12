From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Mon, 12 Mar 2018 10:22:00 -0700
Message-ID: <1f3e2c92-1e09-cc77-3b90-e33d7da35a2f@fb.com>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
 <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
 <20180309.135724.452219538059491199.davem@davemloft.net>
 <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
 <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
 <81b7599d-aab7-6cb6-7843-64510c8f6260@fb.com>
 <20180310140843.GP4449@wotan.suse.de> <20180310151652.GV4449@wotan.suse.de>
 <20180310153431.GW4449@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180310153431.GW4449@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Djalal Harouni <tixxdz@gmail.com>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/10/18 7:34 AM, Luis R. Rodriguez wrote:
> Also,
>
> Alexei you never answered my questions out aliases with the umh modules.
> Long term this important to consider.

aliases always felt like a crutch to me.
I can see an argument when they're used as 'alias pci:* foo'
but the way it's used in networking with ip_set_* and nf-* is
something I prefer not to ever do again.
Definitely no aliases for bpfilter umh.
