From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 09 Mar 2018 13:55:50 -0500 (EST)
Message-ID: <20180309.135550.385837861865623769.davem@davemloft.net>
References: <20180309181527.GA15803@kroah.com>
        <E622B120-3C3A-4A15-8E1B-6F7649038623@amacapital.net>
        <74e26cc0-9e72-f03b-5396-f3480921f234@fb.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <74e26cc0-9e72-f03b-5396-f3480921f234@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ast@fb.com
Cc: luto@amacapital.net, gregkh@linuxfoundation.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, ast@kernel.org, tixxdz@gmail.com, viro@zeniv.linux.org.uk, daniel@iogearbox.net, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexei Starovoitov <ast@fb.com>
Date: Fri, 9 Mar 2018 10:50:49 -0800

> On 3/9/18 10:23 AM, Andy Lutomirski wrote:
>> It might not be totally crazy to back it by tmpfs.
> 
> interesting. how do you propose to do it?
> Something like:
> - create /umh_module_tempxxx dir
> - mount tmpfs there
> - copy elf into it and exec it?

I think the idea is that it's an internal tmpfs mount that only
the kernel has access too.

And I don't think that even hurts your debuggability concerns.  The
user can just attach using the foo.ko file in the actual filesystem.
