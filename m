From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 09 Mar 2018 13:35:09 -0500 (EST)
Message-ID: <20180309.133509.1275903267249306409.davem@davemloft.net>
References: <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
        <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
        <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: ast@fb.com, luto@amacapital.net, keescook@chromium.org, ast@kernel.org, tixxdz@gmail.com, viro@zeniv.linux.org.uk, daniel@iogearbox.net, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Mar 2018 10:17:42 -0800

>  - use deny_write_access() to make sure that we don't have active
> writers and cannot get them during the execve.

I agree that this is necessary for image validation purposes.
