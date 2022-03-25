public with sharing class CaseTriggerHandler extends TriggerHandler{

    private Case caseBefore = (Case) Trigger.new.get(0);
    /**
     * @description Trigger before insert on Case
     */
    public override void beforeInsert() {
        CaseTriggerHelper.beforeInsertChecker(this.caseBefore);
    }

    /**
     * @description Trigger before Update on Case
     */
    public override void beforeUpdate() {
        CaseTriggerHelper.beforeUpdateChecker(this.caseBefore);
    }
}
