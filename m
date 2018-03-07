From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Wed, 07 Mar 2018 12:22:53 -0500 (EST)
Message-ID: <20180307.122253.868991244559574396.davem@davemloft.net>
References: <20180306013457.1955486-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306013457.1955486-1-ast@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ast@kernel.org
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Mon, 5 Mar 2018 17:34:57 -0800

> As the first step in development of bpfilter project [1] the
> request_module() code is extended to allow user mode helpers to be
> invoked.

Looks like there is a little bit of feedback requiring changes, please
take care of that and resubmit.

Thanks!
