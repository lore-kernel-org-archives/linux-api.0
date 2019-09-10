From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH 0/2] Minor lockdown fixups
Date: Tue, 10 Sep 2019 03:03:16 -0700
Message-ID: <20190910100318.204420-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Constify some arrays and fix an #ifdef that I typoed.
