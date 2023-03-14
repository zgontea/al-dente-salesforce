public without sharing class FilteredQueryBuilder {
    private Map<String, String> params;
    private SortType sortType;
    private String fields;
    private String sObjectType;
    private String limitValue;
    private String offset;

    public FilteredQueryBuilder setParams(Map<String, String> params) {
        this.params = params;
        return this;
    }

    public FilteredQueryBuilder setFields(String fields) {
        this.fields = fields;
        return this;
    }

    public FilteredQueryBuilder setSortType(SortType sortType) {
        this.sortType = sortType;
        return this;
    }

    public FilteredQueryBuilder setSObjectType(String sObjectType) {
        this.sObjectType = sObjectType;
        return this;
    }

    public FilteredQueryBuilder setLimit(String limitValue) {
        this.limitValue = limitValue;
        return this;
    }

    public FilteredQueryBuilder setOffset(String offset) {
        this.offset = offset;
        return this;
    }

    public String buildSOQL() {
        String query = 'SELECT {0} FROM {1}';
        List<String> queryParams = new List<String> {this.fields, this.sObjectType};

        return String.format(query, queryParams);
    }

    public String buildSOSL() {
        String query = 'FIND {0} IN ALL FIELDS RETURNING {1} ({2})';
        List<String> queryParams = new List<String> {'\'' + this.params.get('searchValue') + '*\'', this.sObjectType, this.fields};

        return String.format(query, queryParams);
    }

    public enum SortType {
        ASCENDING,
        DESCENDING
    }
}