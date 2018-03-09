From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 09 Mar 2018 13:57:24 -0500 (EST)
Message-ID: <20180309.135724.452219538059491199.davem@davemloft.net>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
        <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
        <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: luto@amacapital.net, ast@fb.com, keescook@chromium.org, ast@kernel.org, tixxdz@gmail.com, viro@zeniv.linux.org.uk, daniel@iogearbox.net, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Mar 2018 10:53:45 -0800

> Anyway, see my other suggestion that makes this all irrelevant. Just
> wait synchronously (until the exit), and just use deny_write_access().

What exit?

Once the helper UMH is invoked, it runs asynchronously taking eBPF
translation requests.
