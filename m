From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] sock: consistent handling of extreme
 SO_SNDBUF/SO_RCVBUF values
Date: Sat, 16 Feb 2019 18:10:50 -0800 (PST)
Message-ID: <20190216.181050.693622468464700230.davem@davemloft.net>
References: <2cb69b6987b6e23f8b8c1aa8dc524efa6bd53191.1550026643.git.gnault@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <2cb69b6987b6e23f8b8c1aa8dc524efa6bd53191.1550026643.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: gnault@redhat.com
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, edumazet@google.com, mleitner@redhat.com, pabeni@redhat.com
List-Id: linux-api@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Wed, 13 Feb 2019 04:30:34 +0100

> SO_SNDBUF and SO_RCVBUF (and their *BUFFORCE version) may overflow or
> underflow their input value. This patch aims at providing explicit
> handling of these extreme cases, to get a clear behaviour even with
> values bigger than INT_MAX / 2 or lower than INT_MIN / 2.
 ...
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Thank you so much for writing such a detailed commit message.

Applied.
