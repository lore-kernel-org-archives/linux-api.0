From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH V1 01/12] audit: add container id
Date: Sun, 4 Mar 2018 10:01:43 -0500
Message-ID: <CAHC9VhQA23w39aaho1wkPawX7zxiGyTVQroZzpACKk8DK8-F8w@mail.gmail.com>
References: <cover.1519930146.git.rgb@redhat.com>
	<2e5d93ee46feca915a101c2fc3062da674a98223.1519930146.git.rgb@redhat.com>
	<20180303091913.GA13118@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <20180303091913.GA13118@mail.hallyn.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: "Serge E. Hallyn" <serge@hallyn.com>, Richard Guy Briggs <rgb@redhat.com>
Cc: mszeredi@redhat.com, cgroups@vger.kernel.org, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com, Linux-Audit Mailing List <linux-audit@redhat.com>, ebiederm@xmission.com, simo@redhat.com, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>, trondmy@primarydata.com, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Sat, Mar 3, 2018 at 4:19 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> On Thu, Mar 01, 2018 at 02:41:04PM -0500, Richard Guy Briggs wrote:
> ...
>> +static inline bool audit_containerid_set(struct task_struct *tsk)
>
> Hi Richard,
>
> the calls to audit_containerid_set() confused me.  Could you make it
> is_audit_containerid_set() or audit_containerid_isset()?

I haven't gone through the entire patchset yet, but I wanted to
quickly comment on this ... I really dislike the
function-names-as-sentences approach and would would greatly prefer
audit_containerid_isset().

>> +{
>> +     return audit_get_containerid(tsk) != INVALID_CID;
>> +}

-- 
paul moore
www.paul-moore.com
