From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] Add /proc/pid_generation
Date: Wed, 21 Nov 2018 12:31:50 -0800
Message-ID: <20181121203150.GK3065@bombadil.infradead.org>
References: <20181121201452.77173-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121201452.77173-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, timmurray@google.com, primiano@google.com, joelaf@google.com, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Pavel Tatashin <pasha.tatashin@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 12:14:44PM -0800, Daniel Colascione wrote:
> This change adds a per-pid-namespace 64-bit generation number,
> incremented on PID rollover, and exposes it via a new proc file
> /proc/pid_generation. By examining this file before and after /proc
> enumeration, user code can detect the potential reuse of a PID and
> restart the task enumeration process, repeating until it gets a
> coherent snapshot.
> 
> PID rollover ought to be rare, so in practice, scan repetitions will
> be rare.

Then why does it need to be 64-bit?
