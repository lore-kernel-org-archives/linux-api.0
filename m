From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/4] vm: add a syscall to map a process memory into a pipe
Date: Tue, 20 Feb 2018 16:44:06 -0800
Message-ID: <20180220164406.3ec34509376f16841dc66e34@linux-foundation.org>
References: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <gdb-return-46331-gdb-gdb=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:gdb-unsubscribe-gdb-gdb=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:gdb-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/gdb/>
List-Post: <mailto:gdb@sourceware.org>
List-Help: <mailto:gdb-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: gdb-owner@sourceware.org
In-Reply-To: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com>
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, gdb@sourceware.org, devel@lists.open-mpi.org, rr-dev@mozilla.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Andrei Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On Tue,  9 Jan 2018 08:30:49 +0200 Mike Rapoport <rppt@linux.vnet.ibm.com> wrote:

> This patches introduces new process_vmsplice system call that combines
> functionality of process_vm_read and vmsplice.

All seems fairly strightforward.  The big question is: do we know that
people will actually use this, and get sufficient value from it to
justify its addition?
