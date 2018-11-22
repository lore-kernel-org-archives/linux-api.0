From: Kevin Easton <kevin@guarana.org>
Subject: Re: [PATCH] Add /proc/pid_generation
Date: Thu, 22 Nov 2018 11:19:30 +0000
Message-ID: <20181122111930.GA7164@ip-172-31-15-78>
References: <20181121201452.77173-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121201452.77173-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, timmurray@google.com, primiano@google.com, joelaf@google.com, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Pavel Tatashin <pasha.tatashin@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matth
List-Id: linux-api@vger.kernel.org

On Wed, Nov 21, 2018 at 12:14:44PM -0800, Daniel Colascione wrote:
> This change adds a per-pid-namespace 64-bit generation number,
> incremented on PID rollover, and exposes it via a new proc file
> /proc/pid_generation. By examining this file before and after /proc
> enumeration, user code can detect the potential reuse of a PID and
> restart the task enumeration process, repeating until it gets a
> coherent snapshot.

I see downthread this patch has been withdrawn, but nonetheless I'm
still curious - does this actually solve the problem?

It seems to me that a PID could be reused within a scan even if the
generation number remains the same at the beginning and end of a scan:

Say you have a very long-lived task with PID 500 allocated in generation
0.  The PID creation has since wrapped and we are now allocating from the
start of the range again, with generation 1.  We begin a scan of /proc, 
read the generation (1) and at this point, our task dies and PID 500 is
then reallocated to a new task.  We finish our scan, generation is still
1 but PID 500 is now ambiguous.

Am I wrong?

    - Kevin
