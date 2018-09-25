From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/11] UAPI: ndctl: Fix g++-unsupported initialisation in
 headers [ver #2]
Date: Tue, 25 Sep 2018 13:22:21 -0700
Message-ID: <CAPcyv4jjxh955mWEubnGiENVQVeCcZ9YWv8YPBKfWMw-gh1z2w@mail.gmail.com>
References: <153622549721.14298.8116794954073122489.stgit@warthog.procyon.org.uk>
 <153622556444.14298.5971956747198405225.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <153622556444.14298.5971956747198405225.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 6, 2018 at 2:19 AM David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> The following code in the linux/ndctl header file:
>
>         static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
>         {
>                 static const char * const names[] = {
>                         [ND_CMD_ARS_CAP] = "ars_cap",
>                         [ND_CMD_ARS_START] = "ars_start",
>                         [ND_CMD_ARS_STATUS] = "ars_status",
>                         [ND_CMD_CLEAR_ERROR] = "clear_error",
>                         [ND_CMD_CALL] = "cmd_call",
>                 };
>
>                 if (cmd < ARRAY_SIZE(names) && names[cmd])
>                         return names[cmd];
>                 return "unknown";
>         }
>
> is broken in a number of ways:
>
>  (1) ARRAY_SIZE() is not generally defined.
>
>  (2) g++ does not support "non-trivial" array initialisers fully yet.
>
>  (3) Every file that calls this function will acquire a copy of names[].
>
> The same goes for nvdimm_cmd_name().
>
> Fix all three by converting to a switch statement where each case returns a
> string.  That way if cmd is a constant, the compiler can trivially reduce it
> and, if not, the compiler can use a shared lookup table if it thinks that is
> more efficient.
>
> A better way would be to remove these functions and their arrays from the
> header entirely.
>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

...again let me know if you'll take this with g++ series or want me to
carry it directly.
