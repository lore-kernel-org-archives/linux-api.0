From: GeHao Kang <kanghao0928@gmail.com>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Sun, 21 Aug 2016 19:26:04 +0800
Message-ID: <CANv7uPRh4RiSXwpRsOooNAJumMj2TmiRc3Qq5_kwzf9SetE_FA@mail.gmail.com>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
 <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com> <CANv7uPSwu=nxYYjWQFABcyj6ZpAemHyXbn4JnZ6WaVJQd3RX4A@mail.gmail.com>
 <20160819123437.GE10121@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160819123437.GE10121@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org, Paul McKenney <paulmck@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 19, 2016 at 8:34 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> Why are you wanting to use nohz_full if you do syscalls?

We hope to reduce the overhead of the tick while the real time
applications run,
and these applications might do some syscalls to operate the I/O devices like
EtherCAT.
